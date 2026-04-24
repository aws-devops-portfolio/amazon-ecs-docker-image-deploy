package com.devhub164.product.service;

import com.devhub164.product.entity.Product;
import com.devhub164.product.response.ProductResponse;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ProductService {

    private List<Product> productList = new ArrayList<>();

    @PostConstruct
    public void init(){
        this.productList = loadProducts();
    }

    public List<ProductResponse> getProducts() {
        return productList.stream()
                .map(product -> new ProductResponse(
                        product.getId(),
                        product.getName(),
                        product.getSupplier(),
                        product.getPrice()
                ))
        .toList();

    }

    private List<Product> loadProducts() {
        if(productList.isEmpty()){
            productList.add(new Product(10, "Phone", "Mobile Suppliers", 100));
            productList.add(new Product(20, "Tablet", "Mobile Suppliers", 250));
            productList.add(new Product(30, "Laptop", "Computer Shop", 500));
            productList.add(new Product(40, "Monitor", "Digital Dealers", 300));
        }

        return productList;

    }

    public Set<String> getSuppliers() {

        return productList.stream()
                .map(Product::getSupplier)
                .collect(Collectors.toSet());
    }
}
