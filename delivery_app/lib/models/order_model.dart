
class OrderModel {
  double? dCreationTime;
  String? sId;
  Address? address;
  int? createdAt;
  String? deliveryAgent;
  String? deliveryAgentStatus;
  int? deliveryFee;
  String? deliveryMode;
  String? estimatedTime;
  List<Items>? items;
  String? orderId;
  String? orderStatus;
  String? paymentId;
  String? paymentMethod;
  String? paymentStatus;
  String? storeId;
  int? taxes;
  int? total;
  int? updatedAt;
  String? userId;

  OrderModel(
      {this.dCreationTime,
      this.sId,
      this.address,
      this.createdAt,
      this.deliveryAgent,
      this.deliveryAgentStatus,
      this.deliveryFee,
      this.deliveryMode,
      this.estimatedTime,
      this.items,
      this.orderId,
      this.orderStatus,
      this.paymentId,
      this.paymentMethod,
      this.paymentStatus,
      this.storeId,
      this.taxes,
      this.total,
      this.updatedAt,
      this.userId});

  OrderModel.fromJson(Map<String, dynamic> json) {
    dCreationTime = json['_creationTime'];
    sId = json['_id'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    createdAt = json['createdAt'];
    deliveryAgent = json['deliveryAgent'];
    deliveryAgentStatus = json['deliveryAgentStatus'];
    deliveryFee = json['deliveryFee'];
    deliveryMode = json['deliveryMode'];
    estimatedTime = json['estimatedTime'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    orderId = json['orderId'];
    orderStatus = json['orderStatus'];
    paymentId = json['paymentId'];
    paymentMethod = json['paymentMethod'];
    paymentStatus = json['paymentStatus'];
    storeId = json['storeId'];
    taxes = json['taxes'];
    total = json['total'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_creationTime'] = this.dCreationTime;
    data['_id'] = this.sId;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['deliveryAgent'] = this.deliveryAgent;
    data['deliveryAgentStatus'] = this.deliveryAgentStatus;
    data['deliveryFee'] = this.deliveryFee;
    data['deliveryMode'] = this.deliveryMode;
    data['estimatedTime'] = this.estimatedTime;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['orderId'] = this.orderId;
    data['orderStatus'] = this.orderStatus;
    data['paymentId'] = this.paymentId;
    data['paymentMethod'] = this.paymentMethod;
    data['paymentStatus'] = this.paymentStatus;
    data['storeId'] = this.storeId;
    data['taxes'] = this.taxes;
    data['total'] = this.total;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    return data;
  }
}

class Address {
  String? city;
  String? country;
  String? label;
  String? latitude;
  String? longitude;
  String? state;
  String? street;
  String? zip;

  Address(
      {this.city,
      this.country,
      this.label,
      this.latitude,
      this.longitude,
      this.state,
      this.street,
      this.zip});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    label = json['label'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    state = json['state'];
    street = json['street'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    data['label'] = this.label;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['state'] = this.state;
    data['street'] = this.street;
    data['zip'] = this.zip;
    return data;
  }
}

class Items {
  String? category;
  String? color;
  String? image;
  String? name;
  int? price;
  String? productId;
  int? quantity;
  String? size;
  String? subCategory;

  Items(
      {this.category,
      this.color,
      this.image,
      this.name,
      this.price,
      this.productId,
      this.quantity,
      this.size,
      this.subCategory});

  Items.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    color = json['color'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    productId = json['productId'];
    quantity = json['quantity'];
    size = json['size'];
    subCategory = json['subCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['color'] = this.color;
    data['image'] = this.image;
    data['name'] = this.name;
    data['price'] = this.price;
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['size'] = this.size;
    data['subCategory'] = this.subCategory;
    return data;
  }
}
