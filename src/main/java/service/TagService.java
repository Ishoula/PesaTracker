package service;

import models.Tag;
import models.User;
import repository.TagRepository;

import java.util.List;
import java.util.Optional;

public class TagService {

    private final TagRepository tagRepository;

    public TagService() {
        this.tagRepository = new TagRepository();
    }

    public Tag getOrCreateTag(String name, User user, String colorCode) {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        String normalized = name.trim().toLowerCase();

        Optional<Tag> existing = tagRepository.findByNameAndUserId(normalized, user.getId());
        if (existing.isPresent()) {
            return existing.get();
        }

        Tag newTag = new Tag();
        newTag.setName(normalized);
        newTag.setUser(user);
        newTag.setColorCode(colorCode != null ? colorCode : "#D4AF37");
        tagRepository.save(newTag);
        return newTag;
    }

    public List<Tag> getTagsByUser(Long userId) {
        return tagRepository.findByUserId(userId);
    }

    public Tag getTagById(Long id) {
        return tagRepository.findById(id);
    }

    public void deleteTag(Long id) {
        tagRepository.delete(id);
    }
}
