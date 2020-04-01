import 'package:openemr/data/rest_ds.dart';
import 'package:openemr/models/patient.dart';

abstract class PatientListContract {
  void mapData(List<Patient> patient);
}

class PatientListPresenter {
  PatientListContract _view;
  RestDatasource api = new RestDatasource();
  PatientListPresenter(this._view);

  getAllPatients() {
    api.getPatientList().then((List<Patient> list) {
      _view.mapData(list);
    }).catchError((Object error) => print(error.toString()));
    //TODO  Change print with a snackbar/toastmessage
  }
}