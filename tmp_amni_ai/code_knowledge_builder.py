#!/usr/bin/env python3
"""
Amni-A1 Code Knowledge Builder
===============================
Builds comprehensive programming knowledge base for TMU texture maps.
Extracts and learns from language specifications, standard libraries, and syntax.
"""

import inspect
import sys
import json
import os
from pathlib import Path
from typing import Dict, List, Any
import importlib
import pkgutil

class CodeKnowledgeBuilder:
    def __init__(self, atlas_dir: str):
        self.atlas_dir = Path(atlas_dir)
        self.knowledge_dir = self.atlas_dir / "learnings" / "code_knowledge"
        self.knowledge_dir.mkdir(parents=True, exist_ok=True)

    def extract_python_stdlib(self) -> Dict[str, Any]:
        """Extract Python standard library knowledge."""
        knowledge = {
            "language": "python",
            "version": f"{sys.version_info.major}.{sys.version_info.minor}",
            "builtins": {},
            "modules": {},
            "syntax": {},
            "concepts": {}
        }

        # Extract builtins
        import builtins
        for name in dir(builtins):
            if not name.startswith('_'):
                obj = getattr(builtins, name)
                try:
                    if callable(obj):
                        sig = inspect.signature(obj)
                        knowledge["builtins"][name] = {
                            "type": "function",
                            "signature": str(sig),
                            "doc": obj.__doc__ or ""
                        }
                    else:
                        knowledge["builtins"][name] = {
                            "type": "constant",
                            "value": str(obj),
                            "doc": getattr(obj, '__doc__', '') or ""
                        }
                except:
                    knowledge["builtins"][name] = {
                        "type": "object",
                        "info": str(type(obj))
                    }

        # Extract key modules
        key_modules = [
            'os', 'sys', 're', 'json', 'datetime', 'collections',
            'itertools', 'functools', 'math', 'random', 'string',
            'pathlib', 'typing', 'dataclasses', 'enum'
        ]

        for mod_name in key_modules:
            try:
                mod = importlib.import_module(mod_name)
                mod_knowledge = self._extract_module_info(mod, mod_name)
                knowledge["modules"][mod_name] = mod_knowledge
            except ImportError:
                continue

        # Add syntax knowledge
        knowledge["syntax"] = {
            "keywords": [
                "False", "None", "True", "and", "as", "assert", "async", "await",
                "break", "class", "continue", "def", "del", "elif", "else",
                "except", "finally", "for", "from", "global", "if", "import",
                "in", "is", "lambda", "nonlocal", "not", "or", "pass", "raise",
                "return", "try", "while", "with", "yield"
            ],
            "operators": {
                "arithmetic": ["+", "-", "*", "/", "//", "%", "**"],
                "comparison": ["==", "!=", "<", "<=", ">", ">="],
                "logical": ["and", "or", "not"],
                "assignment": ["=", "+=", "-=", "*=", "/=", "//=", "%=", "**="],
                "membership": ["in", "not in"],
                "identity": ["is", "is not"]
            },
            "data_types": ["int", "float", "str", "bool", "list", "tuple", "dict", "set"],
            "control_structures": ["if", "elif", "else", "for", "while", "try", "except", "finally"]
        }

        # Add programming concepts
        knowledge["concepts"] = {
            "oop": {
                "classes": "Blueprint for creating objects",
                "inheritance": "Mechanism for code reuse and hierarchy",
                "polymorphism": "Ability to take multiple forms",
                "encapsulation": "Hiding internal state and requiring interaction through methods"
            },
            "functional": {
                "functions": "Reusable blocks of code",
                "lambda": "Anonymous functions",
                "map_filter_reduce": "Higher-order functions for data transformation",
                "decorators": "Functions that modify other functions"
            },
            "data_structures": {
                "list": "Mutable ordered collection",
                "tuple": "Immutable ordered collection",
                "dict": "Key-value mapping",
                "set": "Unordered unique collection"
            }
        }

        return knowledge

    def _extract_module_info(self, mod, mod_name: str) -> Dict[str, Any]:
        """Extract information from a module."""
        info = {
            "functions": {},
            "classes": {},
            "constants": {},
            "doc": getattr(mod, '__doc__', '') or ""
        }

        for name in dir(mod):
            if name.startswith('_'):
                continue
            try:
                obj = getattr(mod, name)
                if inspect.isfunction(obj) or inspect.ismethod(obj):
                    try:
                        sig = inspect.signature(obj)
                        info["functions"][name] = {
                            "signature": str(sig),
                            "doc": getattr(obj, '__doc__', '') or ""
                        }
                    except:
                        info["functions"][name] = {"signature": "unknown"}
                elif inspect.isclass(obj):
                    try:
                        methods = []
                        for m in dir(obj):
                            if not m.startswith('_'):
                                attr = getattr(obj, m, None)
                                if attr and callable(attr):
                                    methods.append(m)
                        info["classes"][name] = {
                            "doc": getattr(obj, '__doc__', '') or "",
                            "methods": methods[:10]  # First 10 method names
                        }
                    except:
                        info["classes"][name] = {"doc": getattr(obj, '__doc__', '') or ""}
                elif not callable(obj):
                    try:
                        # Only store simple types
                        if isinstance(obj, (int, float, str, bool, type(None))):
                            info["constants"][name] = obj
                        else:
                            info["constants"][name] = str(type(obj).__name__)
                    except:
                        info["constants"][name] = "<unknown>"
            except:
                continue

        return info

    def _make_serializable(self, obj, _seen=None):
        """Convert object to JSON-serializable format."""
        if _seen is None:
            _seen = set()
        
        obj_id = id(obj)
        if obj_id in _seen:
            return "<circular reference>"
        _seen.add(obj_id)
        
        try:
            if isinstance(obj, dict):
                return {k: self._make_serializable(v, _seen) for k, v in obj.items()}
            elif isinstance(obj, list):
                return [self._make_serializable(item, _seen) for item in obj]
            elif isinstance(obj, (int, float, str, bool)) or obj is None:
                return obj
            else:
                return str(obj)
        finally:
            _seen.discard(obj_id)

    def extract_project_knowledge(self, project_path: str) -> List[Dict[str, Any]]:
        """Extract structural knowledge from a specific project directory using AST."""
        import ast
        facts = []
        project_dir = Path(project_path)
        
        if not project_dir.exists():
            return facts

        for py_file in project_dir.rglob("*.py"):
            if ".env" in py_file.parts or "node_modules" in py_file.parts or ".git" in py_file.parts:
                continue
                
            try:
                with open(py_file, "r", encoding="utf-8") as f:
                    content = f.read()
                tree = ast.parse(content)
                
                module_name = py_file.stem
                
                for node in ast.walk(tree):
                    if isinstance(node, ast.FunctionDef):
                        args = [arg.arg for arg in node.args.args]
                        facts.append({
                            "fact": f"In project {project_dir.name}, file {py_file.name} contains function '{node.name}' taking arguments: {', '.join(args)}",
                            "confidence": 1.0,
                            "domain": f"project.{project_dir.name}.code",
                            "related_concepts": ["project_code", module_name, "function", node.name]
                        })
                    elif isinstance(node, ast.ClassDef):
                        methods = [n.name for n in node.body if isinstance(n, ast.FunctionDef)]
                        facts.append({
                            "fact": f"In project {project_dir.name}, file {py_file.name} defines class '{node.name}' with methods: {', '.join(methods)}",
                            "confidence": 1.0,
                            "domain": f"project.{project_dir.name}.code",
                            "related_concepts": ["project_code", module_name, "class", node.name]
                        })
            except Exception as e:
                print(f"Failed to parse {py_file}: {e}")
                
        return facts

    def build_knowledge_base(self):
        """Build and save the code knowledge base."""
        print("Building Python code knowledge base...")

        # Extract Python knowledge
        python_kb = self.extract_python_stdlib()

        # Generate learning facts for Amni-A1
        facts = self._generate_learning_facts(python_kb)
        facts_path = self.knowledge_dir / "python_facts.json"
        with open(facts_path, 'w', encoding='utf-8') as f:
            json.dump(facts, f, indent=2, ensure_ascii=False)

        print(f"Generated {len(facts)} learning facts")

        # Note: Full knowledge base not saved due to serialization issues
        # The facts contain the essential learning data
        return None, facts_path

    def _generate_learning_facts(self, kb: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Generate learning facts from knowledge base for Amni-A1."""
        facts = []

        # Built-in functions
        for name, info in kb["builtins"].items():
            if info["type"] == "function":
                facts.append({
                    "fact": f"Python built-in function {name} has signature {info['signature']}",
                    "confidence": 0.95,
                    "domain": "programming.python.builtins",
                    "related_concepts": ["python", "function", "built-in"]
                })

        # Module functions
        for mod_name, mod_info in kb["modules"].items():
            for func_name, func_info in mod_info["functions"].items():
                facts.append({
                    "fact": f"Python {mod_name}.{func_name} function: {str(func_info.get('signature', 'callable'))}",
                    "confidence": 0.9,
                    "domain": f"programming.python.{mod_name}",
                    "related_concepts": ["python", mod_name, "function"]
                })

        # Classes
            for class_name, class_info in mod_info["classes"].items():
                methods_str = ", ".join(str(m) for m in class_info['methods'][:5])
                facts.append({
                    "fact": f"Python {mod_name}.{class_name} is a class with methods: {methods_str}",
                    "confidence": 0.85,
                    "domain": f"programming.python.{mod_name}",
                    "related_concepts": ["python", mod_name, "class", "oop"]
                })

        # Syntax
        for keyword in kb["syntax"]["keywords"]:
            facts.append({
                "fact": f"'{keyword}' is a Python keyword",
                "confidence": 1.0,
                "domain": "programming.python.syntax",
                "related_concepts": ["python", "keyword", "syntax"]
            })

        # Concepts
        for category, concepts in kb["concepts"].items():
            for concept, description in concepts.items():
                facts.append({
                    "fact": f"In programming, {concept}: {description}",
                    "confidence": 0.9,
                    "domain": f"programming.concepts.{category}",
                    "related_concepts": ["programming", category, concept]
                })

        return facts

    def integrate_with_atlas(self):
        """Integrate code knowledge into Amni-A1's texture maps."""
        # Load facts and feed to learning system
        facts_path = self.knowledge_dir / "python_facts.json"
        if facts_path.exists():
            with open(facts_path, 'r', encoding='utf-8') as f:
                facts = json.load(f)

            # Trigger deep learning on programming concepts
            print(f"Integrating {len(facts)} programming facts into atlas...")

            # This would enqueue facts for learning and texture compilation
            # For now, simulate by adding to knowledge queue
            queue_dir = self.atlas_dir / "learnings" / "knowledge_queue"
            queue_dir.mkdir(exist_ok=True)

            for i, fact in enumerate(facts):
                fact_file = queue_dir / f"programming_fact_{i}.json"
                with open(fact_file, 'w', encoding='utf-8') as f:
                    json.dump(fact, f, ensure_ascii=False)

            print(f"Queued {len(facts)} facts for learning")
            print("Run Amni-A1's deep learning system to process these facts into texture maps")

        print("Code knowledge prepared for atlas integration")

if __name__ == "__main__":
    builder = CodeKnowledgeBuilder("full_lexicon_atlas")
    kb_path, facts_path = builder.build_knowledge_base()
    builder.integrate_with_atlas()