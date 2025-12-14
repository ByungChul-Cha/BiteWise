from django.urls import path
from .views import UserSignupView, UserLoginView
from .views import UserUpdateView, PasswordChangeView, UserLogoutView

urlpatterns = [
    path('signup/', UserSignupView.as_view(), name='user-signup'),
    path('login/', UserLoginView.as_view(), name="user-login"),
    path('logout/', UserLogoutView.as_view(), name='user-logout'),
    path('change/name/', UserUpdateView.as_view(), name='user-update'),
    path('change/password/', PasswordChangeView.as_view(), name='user-password-change'),
]
