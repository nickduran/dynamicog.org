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

**{{ p.director.name }}** — {{ p.director.role }}
{{ p.director.bio }}

---

## Graduate Students

{% if p.grad_students and p.grad_students.size > 0 %}
{% for s in p.grad_students %}
- **{{ s.name }}**{% if s.role %} — {{ s.role }}{% endif %}
{% endfor %}
{% else %}
_Currently recruiting — see [Get Involved](/get-involved/)._
{% endif %}

## Research Assistants
{% for s in p.research_assistants %}
- {{ s.name }}
{% endfor %}

---

## Alumni (Graduate, Committee Chair)
{% for a in p.grad_alumni %}
- **{{ a.name }}**{% if a.placement %} — {{ a.placement }}{% endif %}
{% endfor %}

---

## Faculty Collaborators
{% for c in p.collaborators %}{{ c }}{% unless forloop.last %} · {% endunless %}{% endfor %}
