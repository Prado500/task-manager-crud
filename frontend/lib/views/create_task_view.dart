import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import '../models/task_model.dart';

/// Renders a form interface for creating new tasks.
/// Handles local input validation, date picking, and communicates
/// with the ViewModel to persist the data.
class CreateTaskView extends StatefulWidget {
  const CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;

  // Default values strictly mandated by the technical rubric
  String _selectedStatus = 'pending';
  String _selectedPriority = 'medium';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Triggers the native Material date picker and updates local state.
  Future<void> _pickDueDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Seleccionar fecha límite',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// Validates local form state, constructs the TaskModel, and dispatches
  /// the creation request to the ViewModel.
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una fecha límite.')),
      );
      return;
    }

    // Format DateTime to strict ISO 8601 (YYYY-MM-DD) for Python backend compatibility
    final formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    final newTask = TaskModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: formattedDate,
      priority: _selectedPriority,
      status: _selectedStatus,
    );

    final viewModel = context.read<TaskViewModel>();
    final success = await viewModel.createTask(newTask);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea creada exitosamente.')),
      );
      Navigator.of(context).pop(); // Return to HomeView
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Error desconocido.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TaskViewModel>().isLoading;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Crear Tarea',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Título de la Tarea'),
              TextFormField(
                controller: _titleController,
                maxLength: 150,
                decoration: _inputDecoration('Ej. Preparar reporte Q3'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'El título es obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),

              _buildLabel('Descripción'),
              TextFormField(
                controller: _descriptionController,
                maxLength: 1000,
                maxLines: 4,
                decoration: _inputDecoration('Añade contexto detallado aquí...'),
              ),
              const SizedBox(height: 16),

              _buildLabel('Fecha Límite'),
              InkWell(
                onTap: () => _pickDueDate(context),
                child: InputDecorator(
                  decoration: _inputDecoration('').copyWith(
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Seleccionar fecha (DD/MM/AAAA)'
                        : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                    style: TextStyle(
                      color: _selectedDate == null ? Colors.grey.shade600 : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Estado'),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: _inputDecoration(''),
                          items: const [
                            DropdownMenuItem(value: 'pending', child: Text('Pendiente')),
                            DropdownMenuItem(value: 'in_progress', child: Text('En progreso')),
                            DropdownMenuItem(value: 'completed', child: Text('Completada')),
                          ],
                          onChanged: (val) => setState(() => _selectedStatus = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Prioridad'),
                        DropdownButtonFormField<String>(
                          value: _selectedPriority,
                          decoration: _inputDecoration(''),
                          items: const [
                            DropdownMenuItem(value: 'low', child: Text('Baja')),
                            DropdownMenuItem(value: 'medium', child: Text('Media')),
                            DropdownMenuItem(value: 'high', child: Text('Alta')),
                          ],
                          onChanged: (val) => setState(() => _selectedPriority = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Crear Tarea',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to style field labels consistently.
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  /// Helper method to standardize form input decorations.
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }
}