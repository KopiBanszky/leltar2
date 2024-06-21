enum ItemType { WIDGET, LIST, LARGE }

ItemType convertToItemType(String type) {
  switch (type.toLowerCase()) {
    case 'widget':
      return ItemType.WIDGET;
    case 'list':
      return ItemType.LIST;
    case 'large':
      return ItemType.LARGE;
    default:
      return ItemType.WIDGET;
  }
}

enum Type { CATEGORY, ITEM }

Type convertToType(String type) {
  switch (type.toLowerCase()) {
    case 'category':
      return Type.CATEGORY;
    case 'item':
      return Type.ITEM;
    default:
      return Type.CATEGORY;
  }
}
