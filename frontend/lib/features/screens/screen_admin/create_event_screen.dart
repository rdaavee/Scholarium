import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/event_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key, required bool isBackButtonTrue});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late AdminBloc adminBloc;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? _image;

  @override
  void initState() {
    super.initState();
    final adminRepository = AdminRepositoryImpl();
    final globalRepository = GlobalRepositoryImpl();
    adminBloc = AdminBloc(adminRepository, globalRepository);
  }

  Future<void> _selectImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      print('Image selection error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final String eventName = _eventNameController.text;
      final String description = _descriptionController.text;
      final String date = _dateController.text;
      final String time = _timeController.text;

      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image file.')),
        );
        return;
      }

      final event = EventModel(
        eventName: eventName,
        description: description,
        date: date,
        time: time,
        imageLink: _image!.path,
      );
      adminBloc.add(CreateEvent(event, _image!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => adminBloc,
      child: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AdminLoadingState) {
            return const Center(child: LoadingCircular());
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Create Event'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _eventNameController,
                          decoration: const InputDecoration(
                            labelText: 'Event Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an event name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            labelText: 'Date (YYYY-MM-DD)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                            labelText: 'Time (HH:MM AM/PM)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a time';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        GestureDetector(
                          onTap: _selectImage,
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _image == null
                                ? const Center(
                                    child: Text('Tap to select an image'))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_image!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Create Event'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
