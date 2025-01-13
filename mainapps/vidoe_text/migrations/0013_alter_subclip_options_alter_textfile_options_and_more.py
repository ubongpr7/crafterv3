# Generated by Django 4.2.16 on 2025-01-07 13:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('vidoe_text', '0012_remove_textfile_fps_textfile_created_at'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='subclip',
            options={'ordering': ['main_line__slide', 'position_in_slide']},
        ),
        migrations.AlterModelOptions(
            name='textfile',
            options={'ordering': ['-created_at']},
        ),
        migrations.AddField(
            model_name='subclip',
            name='position_in_slide',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]
