import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shhnatycemexdriver/core/errors/unauthorized_error.dart';
// import 'package:shhnatycemexdriver/features/users_management/infrastructure/users_repository.dart';
import '../constants.dart';

extension FirestoreX on Firestore {
  Future<DocumentReference> myUserDocument() async {
    // final userOption = await UsersRepository().fetchSignedInUser();
    // final user = userOption.getOrElse(() => throw UnauthorizedError());
    // log('user.uid', name: TAG);
    // return Firestore.instance.collection('users').document(user.uid);
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get eventsCollection => collection('events');
//  CollectionReference get ptClientsCollection => collection('pt_clients');
//  CollectionReference get stripeCustomersCollection => collection('stripe_customers');
//  CollectionReference get usersCollection => collection('users');
}
