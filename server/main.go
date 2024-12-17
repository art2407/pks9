package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"unicode/utf8"
)

// Product представляет продукт
type Product struct {
	ID          int     `json:"ID"`
	ImageURL    string  `json:"ImageURL"`
	Name        string  `json:"Name"`
	Description string  `json:"Description"`
	Price       float64 `json:"Price"`
}

// ProductList структура для хранения списка продуктов
type ProductList struct {
	Products []Product `json:"products"`
}

var products []Product

// Загрузка продуктов из JSON файла
func loadProducts() error {
	data, err := ioutil.ReadFile("products.json")
	if err != nil {
		return err
	}

	// Проверка UTF-8 кодировки
	if !utf8.Valid(data) {
		return fmt.Errorf("file is not in UTF-8 encoding")
	}

	var productList ProductList
	err = json.Unmarshal(data, &productList)
	if err != nil {
		return err
	}

	products = productList.Products
	return nil
}

// Сохранение продуктов в JSON файл
func saveProducts() error {
	productList := ProductList{Products: products}
	data, err := json.MarshalIndent(productList, "", "  ")
	if err != nil {
		return err
	}

	return ioutil.WriteFile("products.json", data, 0644)
}

// обработчик для GET-запроса, возвращает список продуктов
func getProductsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	json.NewEncoder(w).Encode(products)
}

// обработчик для POST-запроса, добавляет продукт
func createProductHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	var newProduct Product
	err := json.NewDecoder(r.Body).Decode(&newProduct)
	if err != nil {
		fmt.Println("Error decoding request body:", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Printf("Received new Product: %+v\n", newProduct)
	var lastID int = len(products)

	for _, productItem := range products {
		if productItem.ID > lastID {
			lastID = productItem.ID
		}
	}
	newProduct.ID = lastID + 1
	products = append(products, newProduct)

	err = saveProducts()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	json.NewEncoder(w).Encode(newProduct)
}

func getProductByIDHandler(w http.ResponseWriter, r *http.Request) {
	idStr := r.URL.Path[len("/products/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Product ID", http.StatusBadRequest)
		return
	}

	for _, Product := range products {
		if Product.ID == id {
			w.Header().Set("Content-Type", "application/json; charset=utf-8")
			json.NewEncoder(w).Encode(Product)
			return
		}
	}

	http.Error(w, "Product not found", http.StatusNotFound)
}

func deleteProductHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := r.URL.Path[len("/products/delete/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Product ID", http.StatusBadRequest)
		return
	}

	for i, Product := range products {
		if Product.ID == id {
			products = append(products[:i], products[i+1:]...)
			err = saveProducts()
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			w.WriteHeader(http.StatusNoContent)
			return
		}
	}

	http.Error(w, "Product not found", http.StatusNotFound)
}

func updateProductHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPut {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := r.URL.Path[len("/products/update/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Product ID", http.StatusBadRequest)
		return
	}

	var updatedProduct Product
	err = json.NewDecoder(r.Body).Decode(&updatedProduct)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	for i, Product := range products {
		if Product.ID == id {
			products[i].ImageURL = updatedProduct.ImageURL
			products[i].Name = updatedProduct.Name
			products[i].Description = updatedProduct.Description
			products[i].Price = updatedProduct.Price

			err = saveProducts()
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}

			w.Header().Set("Content-Type", "application/json; charset=utf-8")
			json.NewEncoder(w).Encode(products[i])
			return
		}
	}

	http.Error(w, "Product not found", http.StatusNotFound)
}

func enableCORS(handler http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		handler(w, r)
	}
}

func main() {
	err := loadProducts()
	if err != nil {
		fmt.Println("Error loading products:", err)
		return
	}

	http.HandleFunc("/products", enableCORS(getProductsHandler))
	http.HandleFunc("/products/create", enableCORS(createProductHandler))
	http.HandleFunc("/products/", enableCORS(getProductByIDHandler))
	http.HandleFunc("/products/update/", enableCORS(updateProductHandler))
	http.HandleFunc("/products/delete/", enableCORS(deleteProductHandler))

	fmt.Println("Server is running on port 8080!")
	http.ListenAndServe(":8080", nil)
}
