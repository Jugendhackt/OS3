enum PartDirection { horizontal, vertical }

class SitePart {
  Map<int, SitePart> trchildren = new Map();
  Map<int, SitePart> tdchildren = new Map();
  String value;

  /*void setChildCol(int index, SitePart sp) {
    trchildren[index] = sp;
  }

  void setChildRow(int index, SitePart sp) {
    tdchildren[index] = sp;
  }*/

  void setChildrenDown(String path, String val) {
    print(path);
    print(val);
    if (path.startsWith('[')) {
      int internIndex = int.parse(path.substring(2, 3));

      if (!trchildren.containsKey(internIndex)) {
        trchildren[internIndex] = new SitePart();
      }
      trchildren[internIndex].setChildrenDown(path.substring(3), val);
    } else if (path.startsWith('<')) {
      int internIndex = int.parse(path.substring(2, 3));

      if (!tdchildren.containsKey(internIndex)) {
        tdchildren[internIndex] = new SitePart();
      }
      tdchildren[internIndex].setChildrenDown(path.substring(3), val);
    } else {
      value = val;
    }
  }

  @override
  String toString() {
    return '{trchildren: ${trchildren.toString()}, tdchildren: ${tdchildren
        .toString()}, value: $value}';
  }

/*
  SitePart(this.direction, this.value);
*/
}

class SiteElement {}
