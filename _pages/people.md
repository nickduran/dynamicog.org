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

**{{ p.director.name }}**, {{ p.director.role }}

{{ p.director.bio }}

---

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

## Research Assistants
<div class="people-grid people-grid--ra">
{% for s in p.research_assistants %}
  <div class="person-card">
    {% if s.image %}
      <img class="person-photo" src="{{ s.image | prepend: 'assets/img/people/' | relative_url }}" alt="{{ s.name }}" />
    {% else %}
      <div class="person-photo person-photo--placeholder" aria-hidden="true"><i class="fa-solid fa-user"></i></div>
    {% endif %}
    <div class="person-info">
      <span class="person-name">{{ s.name }}</span>
    </div>
  </div>
{% endfor %}
</div>

---

## Alumni (Graduate, Committee Chair)
{% for a in p.grad_alumni %}
- **{{ a.name }}**{% if a.placement %} — {{ a.placement }}{% endif %}
{% endfor %}

---

## Faculty Collaborators
{% for c in p.collaborators %}{{ c }}{% unless forloop.last %} · {% endunless %}{% endfor %}
