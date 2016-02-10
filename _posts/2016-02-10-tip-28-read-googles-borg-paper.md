---
layout: tip
title: "Tip #28: Read Googles Borg Paper"
date: 2016-02-10 10:15
categories: tips
tags: computers
image: http://d5e3yh7f757go.cloudfront.net/tips/tip-28-Finder-1.jpg
thumbnail: http://d5e3yh7f757go.cloudfront.net/tips/thumbs/tip-28-Finder-1.jpg
---
We're big fans of research papers that describe real-world systems and their successes and failures. A lot of the best ones come from the biggest orgs like Google, Facebook, Yahoo, and Akamai. With the recent fervor around containerization and the management there of, we've been looking back to the early sources like [this paper about Google's Borg system](http://research.google.com/pubs/pub43438.html). Last year Google really started to invest in [open source tooling based on learnings from Borg](http://blog.kubernetes.io/2015/04/borg-predecessor-to-kubernetes.html), specifically [Kubernetes](http://kubernetes.io/). Whether or not you're running at the scale that necessitates this level of abstraction (Bonus Tip: _You're not_), it's still extremely interesting to think about how you would reason about problems at this massive scale. 