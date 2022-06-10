import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

const double kCardHeight = 225;
const double kCardWidth = 356;

const double kSpaceBetweenCard = 24;
const double kSpaceBetweenUnselectCard = 32;
const double kSpaceUnselectedCardToTop = 320;

const Duration kAnimationDuration = Duration(milliseconds: 245);

class CreditCardData {
  CreditCardData({required this.backgroundColor});
  final Color backgroundColor;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(
        cardsData: [
          CreditCardData(
            backgroundColor: Colors.orange,
          ),
          CreditCardData(
            backgroundColor: Colors.grey.shade900,
          ),
          CreditCardData(
            backgroundColor: Colors.cyan,
          ),
          CreditCardData(
            backgroundColor: Colors.blue,
          ),
          CreditCardData(
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
    this.cardsData = const [],
    this.space = kSpaceBetweenCard,
  }) : super(key: key);

  final List<CreditCardData> cardsData;
  final double space;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? selectedCardIndex;

  late final List<CreditCard> creditCards;

  @override
  void initState() {
    super.initState();

    creditCards = widget.cardsData
        .map((data) => CreditCard(
              backgroundColor: data.backgroundColor,
            ))
        .toList();
  }

  int toUnselectedCardPositionIndex(int indexInAllList) {
    if (selectedCardIndex != null) {
      if (indexInAllList < selectedCardIndex!) {
        return indexInAllList;
      } else {
        return indexInAllList - 1;
      }
    } else {
      throw 'Wrong usage';
    }
  }

  double _getCardTopPosititoned(int index, isSelected) {
    if (selectedCardIndex != null) {
      if (isSelected) {
        return widget.space;
      } else {
        /// Space from top to place put unselect cards.
        return kSpaceUnselectedCardToTop +
            toUnselectedCardPositionIndex(index) * kSpaceBetweenUnselectCard;
      }
    } else {
      /// Top first emptySpace + CardSpace + emptySpace + ...
      return widget.space + index * kCardHeight + index * widget.space;
    }
  }

  double _getCardScale(int index, isSelected) {
    if (selectedCardIndex != null) {
      if (isSelected) {
        return 1.0;
      } else {
        int totalUnselectCard = creditCards.length - 1;
        return 1.0 -
            (totalUnselectCard - toUnselectedCardPositionIndex(index) - 1) *
                0.05;
      }
    } else {
      return 1.0;
    }
  }

  void unSelectCard() {
    setState(() {
      selectedCardIndex = null;
    });
  }

  double totalHeightTotalCard() {
    if (selectedCardIndex == null) {
      final totalCard = creditCards.length;
      return widget.space * (totalCard + 1) + kCardHeight * totalCard;
    } else {
      return kSpaceUnselectedCardToTop + kCardHeight + (creditCards.length - 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PICK A CARD'),
      ),
      body: SizedBox.expand(
        child: GestureDetector(
          onVerticalDragEnd: (_) {
            unSelectCard();
          },
          onVerticalDragStart: (_) {
            unSelectCard();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: kAnimationDuration,
                  height: totalHeightTotalCard(),
                  width: mediaQuery.size.width,
                ),
                for (int i = 0; i < creditCards.length; i++)
                  AnimatedPositioned(
                    top: _getCardTopPosititoned(i, i == selectedCardIndex),
                    duration: kAnimationDuration,
                    child: AnimatedScale(
                      scale: _getCardScale(i, i == selectedCardIndex),
                      duration: kAnimationDuration,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCardIndex = i;
                          });
                        },
                        child: creditCards[i],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  const CreditCard({
    Key? key,
    required this.backgroundColor,
  }) : super(key: key);

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CreditCardWidget(
        cardNumber: '374245455400126',
        expiryDate: '05/2023',
        cardHolderName: 'Ethan',
        cvvCode: '123',
        showBackView: false,
        isSwipeGestureEnabled: false,
        height: kCardHeight,
        width: kCardWidth,
        cardBgColor: backgroundColor,
        onCreditCardWidgetChange: (_) {},
      ),
    );
  }
}
