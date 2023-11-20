class Address {
  String? neighborhood;
  String? street;
  String? city;
  String? state;
  String? numExt;
  String? numInt;
  String? country;

  Address({
    this.neighborhood,
    this.street,
    this.city,
    this.state,
    this.numExt,
    this.numInt,
    this.country,
  });

  Address copyWith({
    String? neighborhood,
    String? street,
    String? city,
    String? state,
    String? numExt,
    String? numInt,
    String? country,
  }) =>
      Address(
        neighborhood: neighborhood ?? this.neighborhood,
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        numExt: numExt ?? this.numExt,
        numInt: numInt ?? this.numInt,
        country: country ?? this.country,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        neighborhood: json["neighborhood"],
        street: json["street"],
        city: json["city"],
        state: json["state"],
        numExt: json["num_ext"],
        numInt: json["num_int"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "neighborhood": neighborhood,
        "street": street,
        "city": city,
        "state": state,
        "num_ext": numExt,
        "num_int": numInt,
        "country": country,
      };

  @override
  String toString() {
    // Crear una lista para almacenar partes no nulas de la dirección.
    List<String> addressParts = [];

    if (city != null) addressParts.add(city!);
    if (state != null) addressParts.add(state!);
    if (country != null) addressParts.add('${country!} /');
    if (street != null) addressParts.add(street!);
    if (numExt != null) addressParts.add('${numExt!} /');
    if (numInt != null) addressParts.add('${numInt!} -');
    if (neighborhood != null) addressParts.add(neighborhood!);

    return addressParts.join(' ');
  }
}
