---
layout: page
title: people
permalink: /people/
description: The DynamiCog Lab team, alumni, and collaborators.
nav: true
nav_order: 2
---

{% assign p = site.data.people %}

## Lab Director

<div class="people-grid people-grid--grad">
  <div class="person-card">
    {% if p.director.people_image %}
      <img class="person-photo" src="{{ p.director.people_image | prepend: 'assets/img/people/' | relative_url }}" alt="{{ p.director.name }}" />
    {% else %}
      <div class="person-photo person-photo--placeholder" aria-hidden="true"><i class="fa-solid fa-user"></i></div>
    {% endif %}
    <div class="person-info">
      <span class="person-name">{{ p.director.name }}</span>
      <span class="person-role">{{ p.director.role }}</span>
      <a class="person-cv" href="{% if p.director.cv %}{{ p.director.cv | prepend: 'assets/pdf/' | relative_url }}{% else %}#{% endif %}"{% if p.director.cv %} target="_blank" rel="noopener"{% endif %}><i class="fa-regular fa-file-lines" aria-hidden="true"></i> Curriculum vitae</a>
    </div>
  </div>
</div>

{{ p.director.bio }}

{% if p.director.interests %}
<p class="director-interests"><span class="director-label">Research interests.</span> {{ p.director.interests | join: "; " }}.</p>
{% endif %}

<hr class="section-break">

## Graduate Students

{% if p.grad_students and p.grad_students.size > 0 %}
<div class="people-grid people-grid--grad">
{% for s in p.grad_students %}
  <div class="person-card">
    {% if s.image %}
      <img class="person-photo" src="{{ s.image | prepend: 'assets/img/people/' | relative_url }}" alt="{{ s.name }}" />
    {% else %}
      <div class="person-photo person-photo--placeholder" aria-hidden="true"><i class="fa-solid fa-user"></i></div>
    {% endif %}
    <div class="person-info">
      <span class="person-name">{{ s.name }}</span>
      {% if s.role %}<span class="person-role">{{ s.role }}</span>{% endif %}
    </div>
  </div>
{% endfor %}
</div>
{% else %}
_Currently recruiting — see [Get Involved](/get-involved/)._
{% endif %}

{% if p.lab_manager and p.lab_manager.size > 0 %}
## Lab Manager

<div class="people-grid people-grid--grad">
{% for s in p.lab_manager %}
  <div class="person-card">
    {% if s.image %}
      <img class="person-photo" src="{{ s.image | prepend: 'assets/img/people/' | relative_url }}" alt="{{ s.name }}" />
    {% else %}
      <div class="person-photo person-photo--placeholder" aria-hidden="true"><i class="fa-solid fa-user"></i></div>
    {% endif %}
    <div class="person-info">
      <span class="person-name">{{ s.name }}</span>
      {% if s.role %}<span class="person-role">{{ s.role }}</span>{% endif %}
    </div>
  </div>
{% endfor %}
</div>
{% endif %}

## Research Assistants
<div class="people-grid people-grid--ra">
{% for s in p.research_assistants %}
  <div class="person-card">
    {% if s.image %}
      <img class="person-photo" src="{{ s.image | prepend: 'assets/img/people/' | relative_url }}" alt="{{ s.name }}" />
    {% endif %}
    <div class="person-info">
      <span class="person-name">{{ s.name }}</span>
    </div>
  </div>
{% endfor %}
</div>

<!-- hr.section-break: wider, gold section breaks (Nick, 2026-11-13). Director | current members | alumni | collaborators. -->
<hr class="section-break">

## Alumni (Master's, Committee Chair)
{% for a in p.grad_alumni %}
- **{{ a.name }}**{% if a.note %} ({{ a.note }}){% endif %}{% if a.placement %}, {{ a.placement }}{% endif %}{% if a.year %} ({{ a.year }}){% endif %}
{% endfor %}

<hr class="section-break">

## Faculty Collaborators
{% for c in p.collaborators %}{{ c }}{% unless forloop.last %} · {% endunless %}{% endfor %}
