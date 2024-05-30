import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universus/class/club/clubElement.dart';
import 'SearchResultClubList_Model.dart';
export 'SearchResultClubList_Model.dart';

class SearchResultClubListWidget extends StatefulWidget {
  final List<ClubElement> clubs;

  const SearchResultClubListWidget({Key? key, required this.clubs})
      : super(key: key);

  @override
  State<SearchResultClubListWidget> createState() =>
      _SearchResultClubListWidgetState();
}

class _SearchResultClubListWidgetState
    extends State<SearchResultClubListWidget> {
  late SearchResultClubListModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchResultClubListModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: widget.clubs.length,
      itemBuilder: (context, index) {
        final club = widget.clubs[index];
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-1.01, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    club.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.2, -0.96),
                      child: Text(
                        club.clubName,
                        style: GoogleFonts.getFont(
                          'Readex Pro',
                          fontSize: 17,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.13, 0.02),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                        child: Text(
                          club.introduction ?? 'no',
                          style: GoogleFonts.getFont(
                            'Readex Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 13,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.32, 1.13),
                      child: Text(
                        '👨‍🦳${club.currentMembers}',
                        style: GoogleFonts.getFont(
                          'Readex Pro',
                          letterSpacing: 0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
