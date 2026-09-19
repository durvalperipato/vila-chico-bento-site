/// Strongly-typed icon identifiers for administrative section groups.
enum AdminSectionIcon {
  stars,
  pets,
  category,
  photoLibrary,
  location,
  contactPhone,
  general;

  /// Resolves an [AdminSectionIcon] from a string name
  /// with fallback to [general].
  static AdminSectionIcon fromName(String? name) {
    if (name == null) return AdminSectionIcon.general;
    return switch (name) {
      'stars' => AdminSectionIcon.stars,
      'pets' => AdminSectionIcon.pets,
      'category' => AdminSectionIcon.category,
      'photo_library' || 'photoLibrary' => AdminSectionIcon.photoLibrary,
      'location_on' || 'location' => AdminSectionIcon.location,
      'contact_phone' || 'contactPhone' => AdminSectionIcon.contactPhone,
      _ => AdminSectionIcon.general,
    };
  }
}
