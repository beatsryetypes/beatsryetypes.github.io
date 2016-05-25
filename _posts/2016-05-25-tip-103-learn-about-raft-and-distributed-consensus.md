---
layout: tip
title: "Tip #103: Learn about RAFT and Distributed Consensus"
date: 2016-05-25 10:15
categories: tips
tags: computers
image: http://d5e3yh7f757go.cloudfront.net/tips/tip-103-Raft.jpg
thumbnail: http://d5e3yh7f757go.cloudfront.net/tips/thumbs/tip-103-Raft.jpg
---

If you work on the internet (and especially in the world of systems programming), eventually you're going to run into problems that fall under the umbrella of _distributed computing_. One of the most common and oldest problems is distributed _consensus_. How do you get a group of different systems that can potentially be disconnected at any time agree on a common state? This becomes increasingly important (and hard) when you're dealing with large numbers of nodes and you want near real time guarantees about data. Recently, a group of Ph.D. students worked towards a goal of creating an algorithm for distributed consensus that was easy to describe, understand, and implement: [Raft](https://raft.github.io/). The paper is great, because its _goal_ is to be readily understood, but theres also a great visualization on [The Secret Lives of Data](http://thesecretlivesofdata.com/raft/). Even if systems programming and dist-sys 101 isn't you're thing, theres lots to learn here.