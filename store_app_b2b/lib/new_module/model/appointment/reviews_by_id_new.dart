import 'dart:convert';

ReviewsById reviewsByIdFromJson(String str) =>
    ReviewsById.fromJson(json.decode(str));

String reviewsByIdToJson(ReviewsById data) => json.encode(data.toJson());

class ReviewsById {
  bool? status;
  String? message;
  Data? data;
  dynamic token;

  ReviewsById({this.status, this.message, this.data, this.token});

  factory ReviewsById.fromJson(Map<String, dynamic> json) => ReviewsById(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
        token: json['token'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
        'token': token,
      };
}

class Data {
  List<ReviewDetails>? content;
  Pageable? pageable;
  int? totalElements;
  bool? last;
  int? totalPages;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.totalElements,
    this.last,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: (json['content'] as List<dynamic>?)
            ?.map((e) => ReviewDetails.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        totalElements: json['totalElements'] as int?,
        last: json['last'] as bool?,
        totalPages: json['totalPages'] as int?,
        size: json['size'] as int?,
        number: json['number'] as int?,
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        numberOfElements: json['numberOfElements'] as int?,
        first: json['first'] as bool?,
        empty: json['empty'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'content': content?.map((e) => e.toJson()).toList(),
        'pageable': pageable?.toJson(),
        'totalElements': totalElements,
        'last': last,
        'totalPages': totalPages,
        'size': size,
        'number': number,
        'sort': sort?.toJson(),
        'numberOfElements': numberOfElements,
        'first': first,
        'empty': empty,
      };
}

class ReviewDetails {
  String? id;
  int? rating;
  String? review;
  String? userId;
  String? type;
  String? typeId;
  String? reviewerId;
  String? reviewerName;
  String? reviewerImageId;
  dynamic attachedImages;
  dynamic attachedVedios;

  ReviewDetails({
    this.id,
    this.rating,
    this.review,
    this.userId,
    this.type,
    this.typeId,
    this.reviewerId,
    this.reviewerName,
    this.reviewerImageId,
    this.attachedImages,
    this.attachedVedios,
  });

  factory ReviewDetails.fromJson(Map<String, dynamic> json) => ReviewDetails(
        id: json['id'] as String?,
        rating: json['rating'] as int?,
        review: json['review'] as String?,
        userId: json['userId'] as String?,
        type: json['type'] as String?,
        typeId: json['typeId'] as String?,
        reviewerId: json['reviewerId'] as String?,
        reviewerName: json['reviewerName'] as String?,
        reviewerImageId: json['reviewerImageId'] as String?,
        attachedImages: json['attachedImages'] as dynamic,
        attachedVedios: json['attachedVedios'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'rating': rating,
        'review': review,
        'userId': userId,
        'type': type,
        'typeId': typeId,
        'reviewerId': reviewerId,
        'reviewerName': reviewerName,
        'reviewerImageId': reviewerImageId,
        'attachedImages': attachedImages,
        'attachedVedios': attachedVedios,
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageSize;
  int? pageNumber;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageSize,
    this.pageNumber,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        offset: json['offset'] as int?,
        pageSize: json['pageSize'] as int?,
        pageNumber: json['pageNumber'] as int?,
        paged: json['paged'] as bool?,
        unpaged: json['unpaged'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'sort': sort?.toJson(),
        'offset': offset,
        'pageSize': pageSize,
        'pageNumber': pageNumber,
        'paged': paged,
        'unpaged': unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json['empty'] as bool?,
        sorted: json['sorted'] as bool?,
        unsorted: json['unsorted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'empty': empty,
        'sorted': sorted,
        'unsorted': unsorted,
      };
}
