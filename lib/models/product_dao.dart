class ProductDAO {
  String? idproduct;
  String? description;
  String? imagepath;

  ProductDAO({
    this.idproduct,
    this.description,
    this.imagepath
  });

  Map<String, dynamic> toMap() {
    return {
      'idproduct'   : idproduct,
      'description' : description,
      'imagepath'   : imagepath
    };
  }
}