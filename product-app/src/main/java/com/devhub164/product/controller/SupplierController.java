package com.devhub164.product.controller;

import com.devhub164.product.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Set;

@Slf4j
@RestController
@RequestMapping("/api/v1/suppliers")
public class SupplierController {

    final private ProductService productService;

    public SupplierController(ProductService productService){
        this.productService = productService;
    }

    @GetMapping
    public Set<String> getSuppliers(){
        log.info("Retrieving a list of suppliers");
        return productService.getSuppliers();
    }
}
