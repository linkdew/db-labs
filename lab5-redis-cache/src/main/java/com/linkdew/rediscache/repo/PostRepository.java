package com.linkdew.rediscache.repo;

import com.linkdew.rediscache.model.Post;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostRepository extends JpaRepository<Post, Long> {

}
