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
            productList.add(new Product(1, "Phone", "Mobile Suppliers", 10));
            productList.add(new Product(2, "Tablet", "Mobile Suppliers", 25));
            productList.add(new Product(3, "Laptop", "Computer Shop", 50));
            productList.add(new Product(4, "Monitor", "Digital Dealers", 30));
        }

        return productList;

    }

    public Set<String> getSuppliers() {

        return productList.stream()
                .map(Product::getSupplier)
                .collect(Collectors.toSet());
    }
}
