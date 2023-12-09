import 'package:flutter/material.dart';
import 'package:untitled2/common/const/colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: REMEMBER THINGs
    // IntrinsicHeight를 사용하면 Row에 있는
    // 모든 위젯들이 최대 높이와 동일한 높이를 가지게 된다.
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'asset/img/food/ddeok_bok_gi.jpg',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0,),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '떡볶이',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    '전통 떢볶이의 정석\n맛있음ㅁㄴㅇㅁㅇㅁㅇㅁㅇㄴㅁㅇㅁㅇㅁㄴㅇㅁㅇㅁㄴasdasdadadadsada\n하하하하하ㅁㄴㅇㅁㅇㅁㄴㅇㅁㄴㅇㅁㅇㅁㅇㅁㄴㅇㅁㅇ하',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '₩10000',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}
