package com.linkdew.rediscache.service;

import com.linkdew.rediscache.model.Post;
import com.linkdew.rediscache.repo.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@CacheConfig(cacheNames = "post")
public class PostService {

    private final PostRepository postRepository;

    @Autowired
    public PostService(PostRepository postRepository) {
        this.postRepository = postRepository;
    }

    @Cacheable
    public List<Post> findAll() {
        return postRepository.findAll();
    }

    @Cacheable(key = "#id")
    public Optional<Post> findById(Long id) {
        return postRepository.findById(id);
    }

    @CachePut(key = "#post.id")
    public Post save(Post post) {
        return postRepository.save(post);
    }

    @CacheEvict(key = "#id")
    public void deleteById(Long id) {
        postRepository.deleteById(id);
    }
}