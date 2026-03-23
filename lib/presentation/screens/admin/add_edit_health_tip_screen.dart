import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../../domain/entities/health_article.dart';
import '../../../data/repositories/health_repository_impl.dart';

class AddEditHealthTipScreen extends StatefulWidget {
  final HealthArticle? article;
  const AddEditHealthTipScreen({super.key, this.article});

  @override
  State<AddEditHealthTipScreen> createState() => _AddEditHealthTipScreenState();
}

class _AddEditHealthTipScreenState extends State<AddEditHealthTipScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _summaryController = TextEditingController();
  
  // Quill Controller for Full Content
  late quill.QuillController _quillController;
  final ScrollController _quillScrollController = ScrollController();
  final FocusNode _quillFocusNode = FocusNode();

  final _imageController = TextEditingController();
  final _sourceController = TextEditingController();
  final _categoryController = TextEditingController();
  
  HealthArticleType _selectedType = HealthArticleType.tip;
  int _readTime = 5;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      final a = widget.article!;
      _titleController.text = a.title;
      _subtitleController.text = a.subtitle;
      _summaryController.text = a.summary;
      
      // Load Quill Content
      try {
        final decoded = jsonDecode(a.fullContent);
        if (decoded is List) {
          _quillController = quill.QuillController(
            document: quill.Document.fromJson(decoded),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } else {
          // Fallback if not list
           _quillController = quill.QuillController(
            document: quill.Document()..insert(0, a.fullContent),
            selection: const TextSelection.collapsed(offset: 0),
          );
        }
      } catch (e) {
        // Not JSON, assume plain text (Markdown)
        // Insert as plain text
        _quillController = quill.QuillController(
            document: quill.Document()..insert(0, a.fullContent),
            selection: const TextSelection.collapsed(offset: 0),
        );
      }
      
      _imageController.text = a.imageUrl;
      _sourceController.text = a.source;
      _categoryController.text = a.category;
      _selectedType = a.type;
      _readTime = a.readTimeMin;
    } else {
      _quillController = quill.QuillController(
        document: quill.Document(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  @override
  void dispose() {  
    _titleController.dispose();
    _subtitleController.dispose();
    _summaryController.dispose();
    _quillController.dispose();
    _quillScrollController.dispose();
    _quillFocusNode.dispose();
    _imageController.dispose();
    _sourceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      // Get JSON form of document
      final deltaJson = jsonEncode(_quillController.document.toDelta().toJson());

      final newArticle = HealthArticle(
        id: widget.article?.id ?? '',
        title: _titleController.text,
        subtitle: _subtitleController.text,
        summary: _summaryController.text,
        fullContent: deltaJson, // Store as JSON
        imageUrl: _imageController.text.isEmpty? "https://images.unsplash.com/photo-1505751172876-fa1923c5c528" : _imageController.text, // Default
        source: _sourceController.text,
        category: _categoryController.text,
        type: _selectedType,
        readTimeMin: _readTime,
      );

      final repo = HealthRepositoryImpl();
      try {
        if (widget.article != null) {
          await repo.updateArticle(newArticle);
        } else {
          await repo.addArticle(newArticle);
        }
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }
  
  // Custom styled Input Decoration
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      helperText: " ", // Keeps layout stable
      prefixIcon: Icon(icon, color: Colors.green.shade700, size: 20),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:    const BorderSide(color: Colors.green, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      floatingLabelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.green.shade900,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
            widget.article == null ? "Create New Post" : "Edit Post",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.green.shade900,
          elevation: 0,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text("PUBLISH"),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade700,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Article Type & Category ---
                _buildSectionHeader("Overview"),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Changed to Column to avoid overflow on small screens
                        DropdownButtonFormField<HealthArticleType>(
                          value: _selectedType,
                          decoration: _inputDecoration('Type', Icons.category),
                          items: HealthArticleType.values.map((t) => DropdownMenuItem(
                            value: t, child: Text(t.name.toUpperCase().replaceAll("DIDYOUKNOW", "FUN FACT")),
                          )).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedType = val);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _categoryController,
                          decoration: _inputDecoration('Category', Icons.label_outline),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: _inputDecoration('Article Title', Icons.title).copyWith(
                             hintText: "e.g., 5 Ways to Stay Hydrated",
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        TextFormField(
                          controller: _subtitleController,
                          decoration: _inputDecoration('Subtitle / Hook', Icons.short_text).copyWith(
                            hintText: "Catchy phrase below the title",
                          ),
                        ),
                        Row(
                           children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _sourceController,
                                  decoration: _inputDecoration('Source / Author', Icons.source).copyWith(
                                    hintText: "e.g., WHO or Mayo Clinic",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 140,
                                child: DropdownButtonFormField<int>(
                                  value: _readTime,
                                  decoration: _inputDecoration('Read Time', Icons.timer),
                                  items: [1, 2, 3, 4, 5, 7, 10, 15].map((t) => DropdownMenuItem(
                                    value: t, child: Text("$t min"),
                                  )).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _readTime = val);
                                  },
                                ),
                              ),
                           ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Content ---
                _buildSectionHeader("Content Details"),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _summaryController,
                          decoration: _inputDecoration('Short Summary', Icons.description).copyWith(
                            hintText: "Brief description shown on list view (1-2 sentences)",
                            fillColor: Colors.amber.shade50, // Highlight this is important
                          ),
                          maxLines: 3,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        
                        // --- FULL TEXT EDITOR (Quill) ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text("Full Content", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  quill.QuillSimpleToolbar(
                                    controller: _quillController,
                                    config: const quill.QuillSimpleToolbarConfig(
                                      showSearchButton: false,
                                      showInlineCode: false,
                                      showSubscript: false,
                                      showSuperscript: false,
                                      showCodeBlock: false,
                                      showDirection: false,
                                      // headerStyleType: quill.HeaderStyleType.buttons, // Removed potentially problematic param
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.grey.shade300),
                                  Container(
                                    height: 300, 
                                    padding: const EdgeInsets.all(12),
                                    child: quill.QuillEditor(
                                      focusNode: _quillFocusNode,
                                      scrollController: _quillScrollController,
                                      controller: _quillController,
                                      config: const quill.QuillEditorConfig(
                                        placeholder: 'Start writing...',
                                        scrollable: true,
                                        autoFocus: false,
                                        expands: false,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Media & Metadata ---
                _buildSectionHeader("Media"),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _imageController,
                          decoration: _inputDecoration('Cover Image URL', Icons.image).copyWith(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => setState((){}), 
                              tooltip: "Refresh Preview",
                            ),
                            hintText: "https://..."
                          ),
                          onChanged: (_) => setState((){}),
                        ),
                        if (_imageController.text.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _imageController.text,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_,__,___) => Container(
                                height: 100, 
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                                ), 
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.broken_image, color: Colors.grey.shade400),
                                      const SizedBox(height: 4),
                                      const Text("Invalid Image URL", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
