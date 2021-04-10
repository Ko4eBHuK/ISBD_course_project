from django import forms

from .models import Show

class TournamentCreateForm(forms.Form):
	shows = Show.objects.all()
	title = forms.CharField(max_length=20, required = True)
	time = forms.TimeField(required = True)
	show = forms.ModelChoiceField(required=True, widget=forms.Select, queryset=shows)

