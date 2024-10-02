import 'package:flutter/material.dart';
import 'package:ssoup/theme/text.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;
    double appHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: (115 / 393) * appWidth), // 반응형 패딩
          child: Opacity(
            opacity: 0.60,
            child: Text(
              '내가 모은 스탬프',
              style: medium13.copyWith(
                fontSize: (10 / 393) * appWidth, // 반응형 텍스트 크기
                fontWeight: FontWeight.w500,
                height: 0.21,
                letterSpacing: -0.32,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: (25 / 393) * appWidth), // 반응형 크기
            Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                // Progress bar background
                Container(
                  width: (256 / 393) * appWidth, // 반응형 너비
                  height: (26 / 852) * appHeight, // 반응형 높이
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF5573AC)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                // Filled portion of progress bar
                Container(
                  width: (222 / 393) * appWidth, // 반응형 너비
                  height: (16 / 852) * appHeight, // 반응형 높이
                  decoration: ShapeDecoration(
                    color: const Color(0xFF8ECCFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                // White portion of progress bar
                Container(
                  width: (101 / 393) * appWidth, // 반응형 너비
                  height: (10 / 852) * appHeight, // 반응형 높이
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                // Text displaying progress
                Positioned(
                  left: (225 / 393) * appWidth, // 반응형 위치
                  child: Text(
                    '5/18',
                    style: medium13.copyWith(
                      fontSize: (10 / 393) * appWidth, // 반응형 텍스트 크기
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Circular marker
                Container(
                  width: (45 / 393) * appWidth, // 반응형 크기
                  height: (45 / 393) * appWidth, // 반응형 크기 (가로와 동일)
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(width: 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
