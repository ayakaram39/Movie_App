abstract class GuestSessionState {}

class GuestSessionInitial extends GuestSessionState {}

class GuestSessionLoading extends GuestSessionState {}

class GuestSessionSuccess extends GuestSessionState {
  final String guestSessionId;

  GuestSessionSuccess(this.guestSessionId);
}

class GuestSessionFailure extends GuestSessionState {
  final String message;

  GuestSessionFailure(this.message);
}