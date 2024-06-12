import 'package:flutter_intern/project/technical_models.dart' as t_models;

String getPrefixText(List<t_models.PostLikedBy> postLikedBy){
    return postLikedBy.isEmpty ?  "No one liked this" : postLikedBy.length==1 ? "1 person liked this." : '${postLikedBy.length} people liked this.';
}