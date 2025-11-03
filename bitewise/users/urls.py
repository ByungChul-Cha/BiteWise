from django.urls import path
from .views import UserSignupView, UserLoginView
from .views import UserNameUpdateView, PasswordChangeView

urlpatterns = [
    path('signup/', UserSignupView.as_view(), name='user-signup'),
    path('login/', UserLoginView.as_view(), name="user-login"),
    path('change/name/', UserNameUpdateView.as_view(), name='user-name-update'),
    path('change/password/', PasswordChangeView.as_view(), name='user-password-change'),
]
