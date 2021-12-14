import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junior_test/blocs/actions/ActionsQueryBloc.dart';
import 'package:junior_test/blocs/base/bloc_provider.dart';
import 'package:junior_test/model/RootResponse.dart';
import 'package:junior_test/model/actions/PromoItem.dart';
import 'package:junior_test/resources/api/RootType.dart';
import 'package:junior_test/tools/MyColors.dart';
import 'package:junior_test/tools/MyDimens.dart';
import 'package:junior_test/tools/Strings.dart';
import 'package:junior_test/ui/actions/item/ActionsItemArguments.dart';
import 'package:junior_test/ui/actions/item/ActionsItemWidget.dart';
import 'package:junior_test/ui/base/NewBasePageState.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ActionsWidget extends StatefulWidget {
  static String TAG = "ActionsWidget";

  @override
  _ActionsWidgetState createState() => _ActionsWidgetState();
}

class _ActionsWidgetState extends NewBasePageState<ActionsWidget> {
  ActionsQueryBloc bloc;
  int page = 1;
  int count = 6;
  String url = 'https://bonus.andreyp.ru';

  _ActionsWidgetState() {
    bloc = ActionsQueryBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActionsQueryBloc>(
        bloc: bloc,
        child: getBaseQueryStream(bloc.shopItemContentStream));
  }

  @override
  Widget onSuccess(RootTypes event, RootResponse response) {
    var actionList = response.serverResponse.body.promo.list;
    return getNetworkAppBar(
        null, _getBody(actionList), Strings.actions,
        brightness: Brightness.light);
  }

  void runOnWidgetInit() {
    bloc.loadActionsContent(page, count);
  }

  Widget _getBody(List<PromoItem> actionList) {
    return _actionsGrid(actionList);
  }

  Widget _actionsGrid(List<PromoItem> actionList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StaggeredGridView.countBuilder(
        physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          shrinkWrap: true,
          itemCount: actionList.length,
          itemBuilder: (context, index) {
            return _actionsGridItem(actionList[index]);
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(2, index.isEven ? 2 : 1);
          }),
    );
  }

  Widget _actionsGridItem(PromoItem actionList) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context,
          ActionsItemWidget.TAG,
          arguments: {'actionId': actionList.id},);
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(
          url + actionList.imgFull,),
            fit: BoxFit.fill,
        ),
        ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    actionList.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.white,
                        //fontWeight: FontWeight.bold,
                      fontSize: MyDimens.titleSmall,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10.0,
                bottom: 10.0,
                child: Text(
                  actionList.shop,
                  style: TextStyle(
                    color: MyColors.white,),
                ),
              ),
            ],

          ),),
    );
  }
}
