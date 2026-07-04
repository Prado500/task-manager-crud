import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/task_view_model.dart';

/// Renders the task details interface, allowing users to modify existing tasks.
/// Pre-populates form fields with the injected [TaskModel] data.
class TaskDetailsView extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsView({super.key, required this.task});

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late String _selectedStatus;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');

    // Parse the strict ISO-8601 string back to a DateTime object
    _selectedDate = DateTime.parse(widget.task.dueDate);
    _selectedStatus = widget.task.status;
    _selectedPriority = widget.task.priority;
  }

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
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
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

  /// Validates local form state, packages the payload map, and dispatches
  /// the update request to the ViewModel.
  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final formattedDate = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

    // Creating the payload for partial updates
    final Map<String, dynamic> updates = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'due_date': formattedDate,
      'priority': _selectedPriority,
      'status': _selectedStatus,
    };

    final viewModel = context.read<TaskViewModel>();
    final success = await viewModel.updateTask(widget.task.taskId!, updates);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea actualizada exitosamente.')),
      );
      Navigator.of(context).pop(); // Return to HomeView
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Error al actualizar.')),
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
          'Detalles de Tarea',
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
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                maxLength: 150,
                decoration: const InputDecoration(
                  hintText: 'Título de la tarea',
                  border: InputBorder.none,
                  counterText: "", // Hides the max length counter for a cleaner UI
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'El título es obligatorio'
                    : null,
              ),
              const Divider(),
              const SizedBox(height: 16),

              _buildLabel('Fecha Límite'),
              InkWell(
                onTap: () => _pickDueDate(context),
                child: InputDecorator(
                  decoration: _inputDecoration().copyWith(
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.black87),
                  ),
                  child: Text(
                    '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Estado'),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: _inputDecoration(),
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
                          decoration: _inputDecoration(),
                          items: const [
                            DropdownMenuItem(value: 'low', child: Text('Baja', style: TextStyle(color: Colors.green))),
                            DropdownMenuItem(value: 'medium', child: Text('Media', style: TextStyle(color: Colors.orange))),
                            DropdownMenuItem(value: 'high', child: Text('Alta', style: TextStyle(color: Colors.red))),
                          ],
                          onChanged: (val) => setState(() => _selectedPriority = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildLabel('Descripción'),
              TextFormField(
                controller: _descriptionController,
                maxLength: 1000,
                maxLines: 5,
                decoration: _inputDecoration().copyWith(
                  hintText: 'Actualiza el contexto o los detalles de la tarea...',
                ),
              ),
              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar', style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _submitUpdate,
                      child: const Text('Guardar Cambios', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }
}