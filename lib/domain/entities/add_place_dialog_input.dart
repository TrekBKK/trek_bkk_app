import 'package:trek_bkk_app/domain/entities/place.dart';

class AddPlaceDialogInput {
  Place place;
  bool isSource;
  bool isDestination;

  AddPlaceDialogInput(
      {required this.place,
      required this.isSource,
      required this.isDestination});
}
