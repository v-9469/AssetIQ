package com.example.AssetIq;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@SpringBootApplication
@RestController
@RequestMapping("/api")
public class AssetIqApplication {

	public static void main(String[] args) {
		SpringApplication.run(AssetIqApplication.class, args);
	}

	@GetMapping("/application_health")
		public String hello() {
			return "healthy";
		}
	}

