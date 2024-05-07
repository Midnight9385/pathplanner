import 'package:flutter/material.dart';
import 'package:pathplanner/main.dart';
import 'package:pathplanner/path/pathplanner_path.dart';
import 'package:pathplanner/util/prefs.dart';
import 'package:pathplanner/widgets/editor/tree_widgets/tree_card_node.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditorSettingsTree extends StatefulWidget {
  final bool initiallyExpanded;
  final PathPlannerPath? path;
  final VoidCallback? onPathChanged;

  const EditorSettingsTree({
    super.key,
    this.initiallyExpanded = false, 
    this.onPathChanged,
    required PathPlannerPath? pathP
  }):
    path = pathP
  ;

  @override
  State<EditorSettingsTree> createState() => _EditorSettingsTreeState();
}

class _EditorSettingsTreeState extends State<EditorSettingsTree> {
  late SharedPreferences _prefs;
  bool _snapToGuidelines = Defaults.snapToGuidelines;
  bool _hidePathsOnHover = Defaults.hidePathsOnHover;
  bool _overrideIsHermite = false;
  bool _isHermite = Defaults.hermiteMode;
  PathPlannerPath? path;

  @override
  void initState() {
    super.initState();

    path = widget.path;

    SharedPreferences.getInstance().then((value) {
      setState(() {
        _prefs = value;
        _snapToGuidelines = _prefs.getBool(PrefsKeys.snapToGuidelines) ??
            Defaults.snapToGuidelines;
        _hidePathsOnHover = _prefs.getBool(PrefsKeys.hidePathsOnHover) ??
            Defaults.hidePathsOnHover;
        if(path?.getIsHermiteOverride()!= null){
          _overrideIsHermite = true;
          if(path?.getIsHermiteOverride() == true){
            _isHermite = true;
          }else{
            _isHermite = false;
          }
        }else{
          _isHermite = _prefs.getBool(PrefsKeys.hermiteMode) ??
            Defaults.hermiteMode;
          _overrideIsHermite = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_overrideIsHermite){
      return TreeCardNode(
        initiallyExpanded: widget.initiallyExpanded,
        title: const Text('Editor Settings'),
        children: [
          Row(
            children: [
              Checkbox(
                value: _snapToGuidelines,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _snapToGuidelines = val;
                      _prefs.setBool(PrefsKeys.snapToGuidelines, val);
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 3.0,
                  left: 4.0,
                ),
                child: Text(
                  'Snap To Guidelines',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _hidePathsOnHover,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _hidePathsOnHover = val;
                      _prefs.setBool(PrefsKeys.hidePathsOnHover, val);
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 3.0,
                  left: 4.0,
                ),
                child: Text(
                  'Hide Other Paths on Hover',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _overrideIsHermite,
                onChanged: (val) {
                  if (val != null) {
                    _overrideIsHermite = val; 
                    setState(() {
                      if(!_overrideIsHermite){
                        bool reset = path!.getIsHermiteOverride() == false;
                        path!.setIsHermiteOverride(null);
                        if(reset){
                          widget.onPathChanged?.call();
                        }
                      }else{
                        if(!_isHermite){
                          path!.setIsHermiteOverride(_isHermite);
                          widget.onPathChanged?.call();
                        }
                      }              
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 3.0,
                  left: 4.0,
                ),
                child: Text(
                  'Override Is Hermite',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 0.0,
                  left: 8.0,
                ),
              ),
              Checkbox(
                tristate: true,
                value: !_overrideIsHermite?null:_isHermite,
                activeColor: !_overrideIsHermite?const Color.fromARGB(0, 255, 255, 255): Theme.of(context).colorScheme.secondary,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _isHermite = val;
                      if(path != null){
                      if(_overrideIsHermite){
                        path!.setIsHermiteOverride(_isHermite);
                        widget.onPathChanged?.call();
                      }else{
                        path!.setIsHermiteOverride(null);
                        widget.onPathChanged?.call();
                      }
                      }
                    });
                  }else{
                    setState(() {
                      _isHermite = false;
                      if(_overrideIsHermite){
                        if(_overrideIsHermite){
                          path!.setIsHermiteOverride(_isHermite);
                          widget.onPathChanged?.call();
                        }else{
                          path!.setIsHermiteOverride(null);
                          widget.onPathChanged?.call();
                        }
                      }
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 3.0,
                  left: 4.0,
                ),
                child: Text(
                  'Is Hermite',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      );
    }else{
      return TreeCardNode(
        initiallyExpanded: widget.initiallyExpanded,
        title: const Text('Editor Settings'),
        children: [
          Row(
            children: [
              Checkbox(
                value: _snapToGuidelines,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _snapToGuidelines = val;
                      _prefs.setBool(PrefsKeys.snapToGuidelines, val);
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 3.0,
                  left: 4.0,
                ),
                child: Text(
                  'Snap To Guidelines',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _hidePathsOnHover,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _hidePathsOnHover = val;
                      _prefs.setBool(PrefsKeys.hidePathsOnHover, val);
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 3.0,
                  left: 4.0,
                ),
                child: Text(
                  'Hide Other Paths on Hover',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _overrideIsHermite,
                onChanged: (val) {
                  if (val != null) {
                    _overrideIsHermite = val; 
                    setState(() {
                      if(!_overrideIsHermite){
                        bool reset = path!.getIsHermiteOverride() == false;
                        path!.setIsHermiteOverride(null);
                        if(reset){
                          widget.onPathChanged?.call();
                        }
                      }else{
                        if(!_isHermite){
                          path!.setIsHermiteOverride(_isHermite);
                          widget.onPathChanged?.call();
                        }
                      }              
                    });
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 3.0,
                  left: 4.0,
                ),
                child: Text(
                  'Override Is Hermite',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          )
        ],
      );
    }
  }  
}
