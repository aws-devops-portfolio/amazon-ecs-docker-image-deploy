package com.devhub164.product.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.Mapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.devhub164.product.service.ProductService;

import java.util.List;

@RestController
@RequestMapping("api/v1")
public class ProductController {

    final private ProductService productService;

    public ProductController(ProductService productService){
        this.productService = productService;
    }

    @GetMapping("/products")
    public List<String> getProducts(){
        return productService.getProducts();

    }

}
