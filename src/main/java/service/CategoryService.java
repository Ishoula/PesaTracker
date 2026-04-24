package service;

import models.Category;
import repository.CategoryRepository;
import java.util.List;

public class CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryService() {
        this.categoryRepository = new CategoryRepository();
    }

    /**
     * Finds or Creates a category by name.
     * Normalizes input to Title Case (e.g., "travel" -> "Travel")
     */
    public Category getOrCreateCategory(String name) {
        if (name == null || name.trim().isEmpty()) {
            name = "Uncategorized";
        }

        // Normalization: Title Case
        String normalized = name.trim().toLowerCase();
        normalized = normalized.substring(0, 1).toUpperCase() + normalized.substring(1);

        final String finalName = normalized;

        return categoryRepository.findByName(finalName)
                .orElseGet(() -> {
                    Category newCat = new Category();
                    newCat.setName(finalName);
                    categoryRepository.save(newCat);
                    return newCat;
                });
    }

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    public Category getCategoryById(Long id) {
        return categoryRepository.findById(id);
    }
}