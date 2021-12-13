package com.linkdew.rediscache.model;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Data
@Entity
public class Post implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long post_id;
    private Long user_id;
    private int rating;
    private Date creation_date;
    private String post_name;
    private String post_text;
    private String status;

}