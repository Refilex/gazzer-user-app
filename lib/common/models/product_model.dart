class ProductModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<Product>? products;

  ProductModel({this.totalSize, this.limit, this.offset, this.products});

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset =
        (json['offset'] != null && json['offset'].toString().trim().isNotEmpty)
            ? int.parse(json['offset'].toString())
            : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        if (v['variations'] == null ||
            v['variations'].isEmpty ||
            v['variations'][0]['values'] != null) {
          products!.add(Product.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  String? image;
  int? categoryId;
  List<CategoryIds>? categoryIds;
  List<Variation>? variations;
  List<AddOns>? addOns;
  List<ChoiceOptions>? choiceOptions;
  double? price;
  double? tax;
  double? discount;
  String? discountType;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int? restaurantId;
  String? restaurantName;
  double? restaurantDiscount;
  int? restaurantStatus;
  bool? scheduleOrder;
  double? avgRating;
  int? ratingCount;
  int? veg;
  int? cartQuantityLimit;
  bool? isRestaurantHalalActive;
  bool? isHalalFood;
  String? stockType;
  int? itemStock;
  Category? category;

  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.categoryId,
    this.categoryIds,
    this.variations,
    this.addOns,
    this.choiceOptions,
    this.price,
    this.tax,
    this.discount,
    this.discountType,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.restaurantId,
    this.restaurantName,
    this.restaurantDiscount,
    this.restaurantStatus,
    this.scheduleOrder,
    this.avgRating,
    this.ratingCount,
    this.veg,
    this.cartQuantityLimit,
    this.isRestaurantHalalActive,
    this.isHalalFood,
    this.stockType,
    this.itemStock,
    this.category,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    categoryId = json['category_id'];
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if (json['variations'] != null) {
      variations = [];
      json['variations'].forEach((v) {
        variations!.add(Variation.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = [];
      if (json['add_ons'].length > 0 && json['add_ons'][0] != '[') {
        json['add_ons'].forEach((v) {
          addOns!.add(AddOns.fromJson(v));
        });
      } else if (json['addons'] != null) {
        json['addons'].forEach((v) {
          addOns!.add(AddOns.fromJson(v));
        });
      }
    }
    if (json['choice_options'] != null && json['choice_options'] is! String) {
      choiceOptions = [];
      json['choice_options'].forEach((v) {
        choiceOptions!.add(ChoiceOptions.fromJson(v));
      });
    }
    price = json['price'].toDouble();
    tax = json['tax']?.toDouble();
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    restaurantDiscount = json['restaurant_discount'].toDouble();
    restaurantStatus = json['restaurant_status'];
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count'];
    veg = json['veg'] != null ? int.parse(json['veg'].toString()) : 0;
    cartQuantityLimit = json['maximum_cart_quantity'];
    isRestaurantHalalActive = json['halal_tag_status'] == 1;
    isHalalFood = json['is_halal'] == 1;
    stockType = json['stock_type'];
    itemStock = int.tryParse(json['item_stock'].toString());
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['category_id'] = categoryId;
    if (categoryIds != null) {
      data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    }
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    if (choiceOptions != null) {
      data['choice_options'] = choiceOptions!.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['price'] = price;
    data['tax'] = tax;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['restaurant_id'] = restaurantId;
    data['restaurant_name'] = restaurantName;
    data['restaurant_discount'] = restaurantDiscount;
    data['restaurant_status'] = restaurantStatus;
    data['schedule_order'] = scheduleOrder;
    data['avg_rating'] = avgRating;
    data['rating_count'] = ratingCount;
    data['veg'] = veg;
    data['maximum_cart_quantity'] = cartQuantityLimit;
    data['halal_tag_status'] = isRestaurantHalalActive;
    data['is_halal'] = isHalalFood;
    data['stock_type'] = stockType;
    data['item_stock'] = itemStock;
    return data;
  }
}

class CategoryIds {
  String? id;

  CategoryIds({this.id});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Variation {
  int? variationId;
  String? name;
  String? type;
  bool? multiSelect;
  int? min;
  int? max;
  bool? required;
  List<VariationValue>? variationValues;
  int? qty;
  Variation(
      {this.variationId,
      this.name,
      this.type,
      this.multiSelect,
      this.min,
      this.max,
      this.required,
    this.variationValues,
    this.qty,
  });

  Variation.fromJson(Map<String, dynamic> json) {
    if (json['max'] != null) {
      variationId = json['variation_id'];
      name = json['name'];
      type = json['type'].toString();
      multiSelect = json['type'] == 'multi';
      min = multiSelect! ? int.parse(json['min'].toString()) : 0;
      max = multiSelect! ? int.parse(json['max'].toString()) : 0;
      required = json['required'] == 'on';
      if (json['values'] != null) {
        variationValues = [];
        json['values'].forEach((v) {
          variationValues!.add(VariationValue.fromJson(v));
        });
      }
      qty = json['qty'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = multiSelect;
    data['min'] = min;
    data['max'] = max;
    data['required'] = required;
    if (variationValues != null) {
      data['values'] = variationValues!.map((v) => v.toJson()).toList();
    }
    data['qty'] = qty;
    return data;
  }
}

class VariationValue {
  String? level;
  double? optionPrice;
  bool? isSelected;
  String? stockType;
  int? currentStock;
  int? optionId;

  VariationValue(
      {this.level,
      this.optionPrice,
      this.isSelected,
      this.stockType,
      this.currentStock,
      this.optionId});

  VariationValue.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = double.parse(json['optionPrice'].toString());
    isSelected = json['isSelected'];
    stockType = json['stock_type'];
    currentStock = int.tryParse(json['current_stock'].toString());
    optionId = json['option_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = level;
    data['optionPrice'] = optionPrice;
    data['isSelected'] = isSelected;
    data['stock_type'] = stockType;
    data['current_stock'] = currentStock;
    data['option_id'] = optionId;
    return data;
  }
}

class AddOns {
  int? id;
  String? name;
  double? price;
  String? stockType;
  int? addonStock;

  AddOns({
    this.id,
    this.name,
    this.price,
    this.stockType,
    this.addonStock,
  });

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'].toDouble();
    stockType = json['stock_type'];
    addonStock = json['addon_stock'] != null
        ? int.parse(json['addon_stock'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['stock_type'] = stockType;
    data['addon_stock'] = addonStock;
    return data;
  }
}

class ChoiceOptions {
  String? name;
  String? title;
  List<String>? options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['options'] = options;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? image;
  int? parentId;
  int? position;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? priority;
  String? slug;
  List<Translations>? translations;

  Category(
      {this.id,
      this.name,
      this.image,
      this.parentId,
      this.position,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.priority,
      this.slug,
      this.translations});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    parentId = json['parent_id'];
    position = json['position'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priority = json['priority'];
    slug = json['slug'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['parent_id'] = this.parentId;
    data['position'] = this.position;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['priority'] = this.priority;
    data['slug'] = this.slug;
    if (this.translations != null) {
      data['translations'] = this.translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  dynamic createdAt;
  dynamic updatedAt;

  Translations(
      {this.id,
      this.translationableType,
      this.translationableId,
      this.locale,
      this.key,
      this.value,
      this.createdAt,
      this.updatedAt});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['translationable_type'] = this.translationableType;
    data['translationable_id'] = this.translationableId;
    data['locale'] = this.locale;
    data['key'] = this.key;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
