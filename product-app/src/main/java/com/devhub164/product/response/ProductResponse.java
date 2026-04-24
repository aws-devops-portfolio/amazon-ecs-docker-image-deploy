package com.devhub164.product.response;

public record ProductResponse(
        int id,
        String name,
        String supplier,
        double price) {
}
