package com.devhub164.product.service;

import com.devhub164.product.entity.Product;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class ProductServiceTest {

    @Autowired
    private ProductService productService;

    @Test
    public void shouldGetProducts() {
        List<Product> result = productService.getProducts();
        assertNotNull(result);
        assertEquals(4, result.size());
    }

}