class Produit {
  String nom;
  String image;
  String description;

  Produit({
    required this.nom,
    required this.image,
    required this.description,
  });
String get _nom => nom;
String get _image => image;
String get _description => description;
}