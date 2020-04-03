trigger TriggerUser on User (after Update,before update,before insert) {
    new TriggerUserHandler().run();
}