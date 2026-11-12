---
layout: page
title: publications
permalink: /publications/
description: >
  Peer-reviewed journal and conference publications, book chapters, and commentaries.
  PDFs are provided for personal use only. Code (GitHub) and data (OSF) are linked when
  available. Student and postdoctoral collaborators are noted in the source list.
nav: true
nav_order: 3
---

<!-- _pages/publications.md -->
<!--
  This page renders automatically from _bibliography/papers.bib via jekyll-scholar,
  grouped by year (newest first). To add a paper: add one BibTeX entry to papers.bib,
  drop the PDF in assets/pdf/ (or link a URL), then push.
-->

<!-- Bibsearch Feature -->
{% include bib_search.liquid %}

<div class="publications">

{% bibliography %}

</div>
