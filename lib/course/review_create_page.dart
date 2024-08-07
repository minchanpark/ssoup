import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/color.dart';

class ReviewCreatePage extends StatefulWidget {
  const ReviewCreatePage({super.key});

  @override
  State<ReviewCreatePage> createState() => _ReviewCreatePageState();
}

class _ReviewCreatePageState extends State<ReviewCreatePage> {
  final TextEditingController reviewController = TextEditingController();
  int currentLength = 0;
  final int maxLength = 1000;

  @override
  void initState() {
    super.initState();
    reviewController.addListener(() {
      setState(() {
        currentLength = reviewController.text.length;
      });
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '리뷰작성하기',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'S-Core Dream',
            fontWeight: FontWeight.w200,
            height: 0.07,
            letterSpacing: -0.32,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: null,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  indent: screenWidth * (25 / 393),
                  endIndent: screenWidth * (25 / 393),
                  color: Color.fromARGB(255, 25, 25, 25),
                ),
                SizedBox(height: screenHeight * (21 / 852)),
                Container(
                  padding: EdgeInsets.only(left: screenWidth * (26 / 393)),
                  height: screenHeight * (20 / 852),
                  child: const Text(
                    '*별점을 남겨주세요',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'S-Core Dream',
                      fontWeight: FontWeight.w200,
                      height: 0.09,
                      letterSpacing: -0.32,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      5,
                      (index) => IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.star,
                              color: AppColor.button,
                              size: 35,
                            ),
                          )),
                ),
                Divider(
                  indent: screenWidth * (25 / 393),
                  endIndent: screenWidth * (25 / 393),
                  color: Color(0xffadaaaa),
                ),
                SizedBox(height: screenHeight * (16 / 852)),
                Container(
                  padding: EdgeInsets.only(left: screenWidth * (26 / 393)),
                  height: screenHeight * (20 / 852),
                  child: const Text(
                    '*솔직한 리뷰를 작성해주세요',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'S-Core Dream',
                      fontWeight: FontWeight.w200,
                      height: 0.09,
                      letterSpacing: -0.32,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * (26 / 393)),
                  child: Stack(
                    children: [
                      Container(
                        width: screenWidth * (343 / 393),
                        height: screenHeight * (193 / 852),
                        padding:
                            EdgeInsets.only(left: screenWidth * (13 / 393)),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff000000),
                            width: 0.5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9),
                          ),
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          controller: reviewController,
                          cursorColor: const Color(0xff50A2FF),
                          maxLengthEnforcement: MaxLengthEnforcement.none,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'OO님의 리뷰는 다른 참여자분들에게 큰 도움이 될 수 있어요.',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              fontFamily: 'S-Core Dream',
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * (167 / 852),
                        left: screenWidth * (299 / 393),
                        child: Text(
                          '$currentLength/$maxLength',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
