package com.devhub164.product.service;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
public class ProductService {

    private List<String> productList;

    private final Resource productResource;

    @Value("${app.product-file}")
    private String productFile;

    public ProductService(@Value("${app.product-file}") Resource productResource){
        this.productResource = productResource;
    }

    @PostConstruct
    public void init(){
        this.productList = loadProducts();
    }

    public List<String> getProducts() {
        log.info("Retrieving a list of products");
        return Collections.unmodifiableList(productList);
    }

    private List<String> loadProducts() {
        List<String> products = new ArrayList<>();

        if (!productResource.exists()){
            throw new IllegalStateException("Product file not found " + productResource.getDescription());
        }

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(productResource.getInputStream()))){
            return reader.lines()
                    .filter(line -> !line.isBlank())
                    .collect(Collectors.toList());

        }
        catch(IOException ex){
            log.error("Failed to load products file", ex);
            throw new IllegalStateException("Unable to load product file", ex);
        }

    }
    
}
