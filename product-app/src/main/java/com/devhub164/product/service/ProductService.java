package com.devhub164.product.service;

import com.devhub164.product.entity.Product;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
public class ProductService {

    private List<Product> productList;

    @PostConstruct
    public void init(){
        this.productList = loadProducts();
    }

    public List<Product> getProducts() {
        log.info("Retrieving a list of products");
        return Collections.unmodifiableList(productList);
    }

    private List<Product> loadProducts() {
        List<Product> products = new ArrayList<>();

        products.add(new Product(10, "Phone", "Mobile Suppliers", 100));
        products.add(new Product(20, "Tablet", "Mobile Suppliers", 250));
        products.add(new Product(30, "Laptop", "Computer Shop", 500));
        products.add(new Product(40, "Monitor", "Digital Dealers", 300));
        products.add(new Product(50, "Hard Drive", "Computer Shop", 150));
        products.add(new Product(60, "Solid State Drive", "Computer Shop", 250));

        return products;

    }
    
}
