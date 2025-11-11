---
layout: default
title: SHI Collaboration Profiles
---

<div class="profiles-grid">
{% assign profiles_sorted = site.profiles | sort: 'name' %}
{% for profile in profiles_sorted %}
  <div class="profile-card">
    {% if profile.image %}
      <img src="{{ profile.image | relative_url }}" alt="{{ profile.name }}" class="profile-card-image">
    {% else %}
      <div class="profile-card-image-placeholder">
        <span>{{ profile.name | slice: 0 | upcase }}</span>
      </div>
    {% endif %}
    
    <div class="profile-card-content">
      <h3><a href="{{ profile.url | relative_url }}">{{ profile.name }}</a></h3>
      <p class="profile-card-title">{{ profile.institution }}</p>
      <p class="profile-card-bio">{{ profile.biography | truncate: 150 }}</p>
      
      <div class="profile-card-links">
        {% if profile.linkedin %}
          <a href="{{ profile.linkedin }}" target="_blank" title="LinkedIn Profile">💼</a>
        {% endif %}
        {% if profile.github and profile.github != "" %}
          <a href="{{ profile.github }}" target="_blank" title="GitHub Profile">👨‍💻</a>
        {% endif %}
        {% if profile.website and profile.website != "" %}
          <a href="{{ profile.website }}" target="_blank" title="Personal Website">🌐</a>
        {% endif %}
      </div>
    </div>
  </div>
{% endfor %}
</div>
