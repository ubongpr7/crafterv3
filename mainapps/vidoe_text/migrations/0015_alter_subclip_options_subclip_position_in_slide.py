# Generated by Django 4.2.16 on 2025-01-07 17:06

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('vidoe_text', '0014_alter_subclip_options_and_more'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='subclip',
            options={'ordering': ['main_line__slide', 'position_in_slide']},
        ),
        migrations.AddField(
            model_name='subclip',
            name='position_in_slide',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]